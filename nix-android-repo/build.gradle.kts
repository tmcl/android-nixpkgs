import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.3.31"
    application
}

application {
    mainClassName = "codes.tad.nixandroidrepo.MainKt"
}

repositories {
    jcenter()
    google()
}

dependencyLocking {
    lockAllConfigurations()
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))
    implementation("com.android.tools:sdklib:latest.release")
}

tasks {
    withType<KotlinCompile> {
        kotlinOptions {
            jvmTarget = "1.8"
        }
    }

    withType<Wrapper> {
        gradleVersion = "5.4.1"
    }
}