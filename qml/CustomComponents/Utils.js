function getIconPathById(model, iconId) {
    for (let i = 0; i < model.count; ++i) {
        if (model.get(i).iconId === iconId)
            return model.get(i).path;
    }
    return "qrc:/images/nonemo.png";
}

function formatTodayDate() {
    var d = new Date();
    var months = ["января", "февраля", "марта", "апреля", "мая", "июня",
                  "июля", "августа", "сентября", "октября", "ноября", "декабря"];
    return d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear();
}

function getDaysInMonth(year, month) {
    return new Date(year, month, 0).getDate();
}

function formatMonthKey(year, month) {
    return year + "-" + (month < 10 ? "0" + month : month);
}

function getPreviousMonthKey(year, month) {
    var prevMonth = month - 1;
    var prevYear = year;
    if (prevMonth === 0) {
        prevMonth = 12;
        prevYear -= 1;
    }
    return {
        year: prevYear,
        month: prevMonth,
        key: formatMonthKey(prevYear, prevMonth)
    };
}

