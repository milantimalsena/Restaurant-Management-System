package com.restaurant.controller;

import com.restaurant.dao.ReservationDAO;
import com.restaurant.model.Reservation;
import com.restaurant.model.RestaurantTable;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public class CustomerReservationServlet extends HttpServlet {
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadReservationPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        String dateValue = ValidationUtil.sanitize(request.getParameter("reservationDate"));
        String timeValue = ValidationUtil.sanitize(request.getParameter("reservationTime"));
        String guestsValue = ValidationUtil.sanitize(request.getParameter("guests"));
        String tableIdValue = ValidationUtil.sanitize(request.getParameter("tableId"));
        String specialRequest = ValidationUtil.sanitize(request.getParameter("specialRequest"));

        if (userId == null
                || !ValidationUtil.isRequiredValid(dateValue)
                || !ValidationUtil.isRequiredValid(timeValue)
                || !ValidationUtil.isValidIntegerRange(guestsValue, 1, 30)
                || !ValidationUtil.isValidIntegerRange(tableIdValue, 1, Integer.MAX_VALUE)) {
            request.setAttribute("errorMessage", "Please choose a valid date, time, guests count, and table.");
            loadReservationPage(request, response);
            return;
        }

        try {
            LocalDate reservationDate = LocalDate.parse(dateValue);
            LocalTime reservationTime = LocalTime.parse(timeValue);
            int guests = Integer.parseInt(guestsValue);
            long tableId = Long.parseLong(tableIdValue);

            RestaurantTable table = reservationDAO.getTableById(tableId);
            if (table == null || !table.isActive() || guests > table.getCapacity()) {
                request.setAttribute("errorMessage", "Selected table is not available for the guest count.");
                loadReservationPage(request, response);
                return;
            }

            if (!reservationDAO.isTableAvailable(tableId, reservationDate, reservationTime)) {
                request.setAttribute("fullyBooked", true);
                loadReservationPage(request, response);
                return;
            }

            Reservation reservation = new Reservation();
            reservation.setUserId(userId);
            reservation.setTableId(tableId);
            reservation.setTableNumber(table.getTableNumber());
            reservation.setReservationDate(reservationDate);
            reservation.setReservationTime(reservationTime);
            reservation.setGuests(guests);
            reservation.setSpecialRequest(specialRequest);

            reservationDAO.createReservation(reservation);
            request.setAttribute("successMessage", "Reservation request submitted. Please wait for admin approval.");
            loadReservationPage(request, response);
        } catch (IllegalArgumentException | SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to create reservation right now.");
            loadReservationPage(request, response);
        }
    }

    private void loadReservationPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long userId = SessionUtil.getLoggedInUserId(request);
        LocalDate date = parseDateOrDefault(request.getParameter("reservationDate"));
        LocalTime time = parseTimeOrDefault(request.getParameter("reservationTime"));

        try {
            List<RestaurantTable> availableTables = reservationDAO.getAvailableTables(date, time);
            request.setAttribute("availableTables", availableTables);
            request.setAttribute("reservationHistory", userId == null ? List.of() : reservationDAO.getReservationsByUser(userId));
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("availableTables", List.of());
            request.setAttribute("reservationHistory", List.of());
            request.setAttribute("errorMessage", "Unable to load reservation tables.");
        }

        request.getRequestDispatcher("/customer/reservations-view.jsp").forward(request, response);
    }

    private LocalDate parseDateOrDefault(String value) {
        try {
            return ValidationUtil.isRequiredValid(value) ? LocalDate.parse(value) : LocalDate.now();
        } catch (IllegalArgumentException ex) {
            return LocalDate.now();
        }
    }

    private LocalTime parseTimeOrDefault(String value) {
        try {
            return ValidationUtil.isRequiredValid(value) ? LocalTime.parse(value) : LocalTime.of(19, 0);
        } catch (IllegalArgumentException ex) {
            return LocalTime.of(19, 0);
        }
    }
}
