allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // ADDED FIX: force every plugin subproject (including flutter_native_splash)
    // to compile against the same compileSdk as the app, so outdated plugin
    // build.gradle files don't fail the build with AAR metadata errors.
    // NOTE: this MUST be registered here, before evaluationDependsOn(":app")
    // below forces early evaluation of subprojects — otherwise Gradle throws
    // "Cannot run Project.afterEvaluate(Action) when the project is already evaluated."
    afterEvaluate {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.let { android ->
            android.compileSdkVersion(36)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}