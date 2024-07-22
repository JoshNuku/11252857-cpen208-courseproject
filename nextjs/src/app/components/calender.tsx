// components/Calendar.js
import React from "react";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";

const Calendar = () => {
  return (
    <div className="text-black dark:text-white m-5 rounded-lg bg-white md:p-5 p-3 dark:bg-gray-800">
      <FullCalendar
        plugins={[dayGridPlugin]}
        initialView="dayGridMonth"
        events={[
          { title: "event 1", date: "2024-07-01" },
          { title: "event 2", date: "2024-07-02" },
        ]}
        viewClassNames={"p-2"}
      />
    </div>
  );
};

export default Calendar;
