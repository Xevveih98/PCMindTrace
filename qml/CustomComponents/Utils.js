function getIconPathById(model, iconId) {
    for (let i = 0; i < model.count; ++i) {
        if (model.get(i).iconId === iconId)
            return model.get(i).path;
    }
    return "qrc:/icons/add.png";
}

function formatTodayDate() {
    var d = new Date();
    var months = ["января", "февраля", "марта", "апреля", "мая", "июня",
                  "июля", "августа", "сентября", "октября", "ноября", "декабря"];
    return d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear();
}
