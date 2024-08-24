use clap::{Arg, Command};
use std::fs::File;
use std::io::{self, Write};
use std::process;
use reqwest::blocking::Client;
use serde_json::Value;

extern crate reqwest;
extern crate serde_json;
extern crate clap;

fn main() -> Result<(), Box<dyn std::error::Error>> {
        println!("{}", format!("
░▒▓██████████████▓▒░ ░▒▓██████▓▒░ ░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░▒▓████████▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░   ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░   ░▒▓█▓▒░                                                                   
                                                                                       
                    by Maoyue(MagicTeaMC)

       Welcome to use Minecraft server auto setup tool ({})
    
    ", env!("CARGO_PKG_VERSION")));

    let matches = Command::new("Minecraft Server Auto Setup Tool")
        .version(env!("CARGO_PKG_VERSION"))
        .author("Maoyue (MagicTeaMC)")
        .about("Automatically downloads and sets up a Minecraft server")
        .disable_version_flag(true)  // Disable the auto-generated --version flag
        .arg(
            Arg::new("software")
                .long("software")
                .value_name("SOFTWARE")
                .help("Server software to use (paper/folia/purpur)"),
        )
        .arg(
            Arg::new("version")
                .long("version")
                .value_name("VERSION")
                .help("Minecraft version (e.g., 1.21.1)"),
        )
        .arg(
            Arg::new("eula")
                .long("eula")
                .value_name("EULA")
                .help("Accept Mojang EULA (true/false)"),
        )
        .get_matches();

    let project = if let Some(software) = matches.get_one::<String>("software") {
        software.clone()
    } else {
        let mut input = String::new();
        print!("Enter which server software do you want to use (paper/folia/purpur): ");
        io::stdout().flush()?;
        io::stdin().read_line(&mut input)?;
        input.trim().to_string()
    };

    let minecraft_version = if let Some(version) = matches.get_one::<String>("version") {
        version.clone()
    } else {
        let mut input = String::new();
        print!("Enter the Minecraft version (e.g., 1.21.1): ");
        io::stdout().flush()?;
        io::stdin().read_line(&mut input)?;
        input.trim().to_string()
    };

    let eula = if let Some(eula) = matches.get_one::<String>("eula") {
        eula.clone()
    } else {
        let mut input = String::new();
        print!("I accept Mojang EULA https://www.minecraft.net/en-us/eula (true/false): ");
        io::stdout().flush()?;
        io::stdin().read_line(&mut input)?;
        input.trim().to_string()
    };

    if eula != "true" {
        println!("You must accept the Mojang EULA to continue.");
        process::exit(1);
    }

    let mut eula_file = File::create("eula.txt")?;
    writeln!(eula_file, "eula=true")?;
    println!("EULA accepted and eula.txt file created.");

    println!("Start downloading some essential files...");

    let client = Client::new();

    if project == "purpur" {
        let purpur_download_url = format!(
            "https://api.purpurmc.org/v2/purpur/{}/latest/download",
            minecraft_version
        );

        println!("Downloading the latest Purpur version...");
        let mut response = client.get(&purpur_download_url).send()?;
        let mut file = File::create("server.jar")?;
        io::copy(&mut response, &mut file)?;

        println!("Download completed");
    } else {
        let url = format!(
            "https://api.papermc.io/v2/projects/{}/versions/{}/builds",
            project, minecraft_version
        );

        let response = client.get(&url).send()?;
        let json: Value = response.json()?;

        let latest_build = json["builds"]
            .as_array()
            .ok_or("Unexpected JSON structure")?
            .iter()
            .filter_map(|build| build["build"].as_u64())
            .max();

        if let Some(build) = latest_build {
            println!("Latest build is {}", build);

            let jar_name = format!("{}-{}-{}.jar", project, minecraft_version, build);
            let paper_download_url = format!(
                "https://api.papermc.io/v2/projects/{}/versions/{}/builds/{}/downloads/{}",
                project, minecraft_version, build, jar_name
            );

            println!("Downloading the latest {} version...", project);
            let mut response = client.get(&paper_download_url).send()?;
            let mut file = File::create("server.jar")?;
            io::copy(&mut response, &mut file)?;

            println!("Download completed");
        } else {
            println!("No stable build for version {} found :(", minecraft_version);
        }
    }

    Ok(())
}