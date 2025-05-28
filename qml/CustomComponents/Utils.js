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

function validateEmptyField(field, errorMessage = "* Поле не должно быть пустым") {
    const isEmpty = field.text.trim().length === 0

    if (isEmpty) {
        field.errorText = errorMessage
        field.errorVisible = true
        field.triggerErrorAnimation()
        VibrationUtils.vibrate(200)
    } else {
        field.errorVisible = false
        field.errorText = ""
    }

    return isEmpty
}


function validatePasswordMatch(field1, field2) {
    if (field1.text.trim() !== field2.text.trim()) {
        field2.errorText = "* Пароли не совпадают"
        field2.errorVisible = true
        field2.triggerErrorAnimation()
        VibrationUtils.vibrate(200)
        return true
    } else {
        field2.errorVisible = false
        return false
    }
}

function validatePasswordField(field) {
    let password = field.text.trim()
    let errors = []

    if (/[а-яА-ЯёЁ]/.test(password)) {
        errors.push("* Пароль не должен содержать русские буквы")
    }
    if (!/[a-zA-Z]/.test(password)) {
        errors.push("* Пароль должен содержать хотя бы одну латинскую букву")
    }
    if (!/[-&]/.test(password)) {
        errors.push("* Пароль должен содержать хотя бы один спецсимвол: '-' или '&'")
    }
    if (password.length < 8) {
        errors.push("* Пароль должен содержать минимум 8 символов")
    }

    if (errors.length > 0) {
        field.errorText = errors.join("<br>")
        field.errorVisible = true
        field.triggerErrorAnimation()
        VibrationUtils.vibrate(200)
        return true
    } else {
        field.errorVisible = false
        return false
    }
}

function validateEmailField(field) {
    let email = field.text.trim()
    if (email.length === 0) {
        field.errorText = "* Поле не должно быть пустым"
        field.errorVisible = true
        field.triggerErrorAnimation()
        VibrationUtils.vibrate(200)
        return true
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        field.errorText = "* Некорректный формат email"
        field.errorVisible = true
        field.triggerErrorAnimation()
        VibrationUtils.vibrate(200)
        return true
    } else {
        field.errorVisible = false
        return false
    }
}
