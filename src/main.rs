use std::io::{self, Write};
use std::process;
use std::fs::File;
extern crate reqwest;
use reqwest::blocking::Client;
extern crate serde_json;
use serde_json::Value;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("{}", format!("
       #     #  #####   #####     #     #####  ####### 
       ##   ## #     # #     #   # #   #     #    #    
       # # # # #       #        #   #  #          #    
       #  #  # #        #####  #     #  #####     #    
       #     # #             # #######       #    #    
       #     # #     # #     # #     # #     #    #    
       #     #  #####   #####  #     #  #####     #  
                    by Maoyue(MagicTeaMC)

       Welcome to use Minecraft server auto setup tool ({})
    
    ", env!("CARGO_PKG_VERSION")));

    let mut project = String::new();
    print!("Enter which server software do you want to use (paper/folia): ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut project)?;
    let project = project.trim();

    let mut minecraft_version = String::new();
    print!("Enter the Minecraft version (e.g., 1.21.1): ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut minecraft_version)?;
    let minecraft_version = minecraft_version.trim();

    let mut line = String::new();
    print!("I accept Mojang EULA https://www.minecraft.net/en-us/eula (y/n): ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut line)?;
    let line = line.trim();

    if line != "y" {
        println!("Exiting...");
        process::exit(1);
    }

    println!("Start downloading some essential files...");

    let url = format!(
        "https://api.papermc.io/v2/projects/{}/versions/{}/builds",
        project, minecraft_version
    );

    let client = Client::new();
    let response = client.get(&url).send()?;
    let json: Value = response.json()?;

    let latest_build = json["builds"]
        .as_array()
        .ok_or("Unexpected JSON structure")?
        .iter()
        .filter(|build| build["channel"] == "default")
        .filter_map(|build| build["build"].as_u64())
        .max();

    if let Some(build) = latest_build {
        println!("Latest stable build is {}", build);
        
        let jar_name = format!("{}-{}-{}.jar", project, minecraft_version, build);
        let download_url = format!(
            "https://api.papermc.io/v2/projects/{}/versions/{}/builds/{}/downloads/{}",
            project, minecraft_version, build, jar_name
        );

        println!("Downloading the latest {} version...", project);
        let mut response = client.get(&download_url).send()?;
        let mut file = File::create("server.jar")?;
        io::copy(&mut response, &mut file)?;

        println!("Download completed");
    } else {
        println!("No stable build for version {} found :(", minecraft_version);
    }

    Ok(())
}