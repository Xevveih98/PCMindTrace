cmake_minimum_required(VERSION 3.16)

project(PCMindTrace VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTORCC ON)


find_package(Qt6 REQUIRED COMPONENTS Quick Sql Core Charts)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPCMindTrace
    main.cpp
    src/AuthUser.h
    src/AuthUser.cpp
    src/AppSave.h
    src/AppSave.cpp
    src/CategoriesUser.cpp
    src/CategoriesUser.h
    src/FoldersUser.h
    src/FoldersUser.cpp
    src/CustomComponentsSingleton.h
    src/TodoUser.h
    src/TodoUser.cpp
    src/EntryUser.cpp
    src/EntryUser.h
    AppConfig.h
    src/EntryUserModel.h
    src/EntryUserModel.cpp
    src/EntriesUser.h
    src/EntriesUser.cpp
    src/UserItem.h
    src/ComputeUser.h
    src/ComputeUser.cpp
    src/vibrationutils.h
    src/vibrationutils.cpp
)

qt_add_qml_module(appPCMindTrace
    URI PCMindTrace
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml android/gradle/wrapper/gradle-wrapper.jar android/gradle/wrapper/gradle-wrapper.properties android/gradle.properties android/gradlew android/gradlew.bat
)

set_target_properties(appPCMindTrace PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPCMindTrace
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set_property(TARGET appPCMindTrace APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/android
)

target_link_libraries(appPCMindTrace
    PRIVATE Qt6::Quick Qt6::Sql Qt6::Core Qt6::Charts
)

target_sources(appPCMindTrace PRIVATE images.qrc qml.qrc components.qrc popups.qrc icons2.qrc icons.qrc)

include(GNUInstallDirs)
install(TARGETS appPCMindTrace
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
