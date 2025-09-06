use colored::Colorize;
use std::process::exit;

pub fn inquired<T>(binding: Result<T, inquire::InquireError>) -> T {
    match binding {
        Ok(t) => t,
        Err(e) => {
            println!("{}: failed to inquire ({:?})", "error".red().bold(), e);
            exit(-1);
        }
    }
}

pub fn get_executable_extension() -> &'static str {
    match std::env::consts::OS {
        "windows" => ".exe",
        _ => "",
    }
}

pub fn get_current_directory_name() -> String {
    std::env::current_dir()
        .unwrap()
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or("<unknown>")
        .to_string()
}

pub fn print_error_and_exit<T>(message: &str, error: T) -> !
where
    T: std::fmt::Debug,
{
    println!("{}: {} ({:?})", "error".red().bold(), message, error);
    exit(-1);
}
