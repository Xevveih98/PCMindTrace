function getIconPathById(model, iconId) {
    for (let i = 0; i < model.count; ++i) {
        if (model.get(i).iconId === iconId)
            return model.get(i).path;
    }
    return "qrc:/icons/add.png";
}
