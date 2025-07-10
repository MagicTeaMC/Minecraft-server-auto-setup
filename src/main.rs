use std::{fs, io::Write, path::Path, process::exit};

use clap::{Parser, Subcommand, ValueEnum};
use colored::Colorize;
use inquire::{Confirm, Select, Text};
use serde::{Deserialize, Serialize};

mod eula;
mod softwares;

const CONFIG_FILE: &str = "mcsast.config.json";

#[derive(Parser)]
#[command(
    version = "2.2.2",
    author = "Maoyue (MagicTeaMC)",
    about = "Manage Paper / Purpur / Folia / Velocity server quickly and easily!"
)]
struct CLI {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// initial setup
    Setup {
        /// software to use (paper/folia/purpur/velocity)
        #[arg(short, long, value_enum)]
        software: Option<Software>,

        /// Minecraft version (eg. 1.21.1)
        #[arg(short, long)]
        mc_version: Option<String>,

        /// do you agree www.minecraft.net/en-us/eula?
        #[arg(short, long)]
        eula: Option<bool>,

        /// skip confirmation prompt
        #[arg(short, default_value_t = false)]
        yes: bool,
    },
    /// update to latest build of this version
    Update,
    /// upgrade to another version
    Upgrade {
        /// your target minecraft version
        #[arg(short, long)]
        version: Option<String>,
    },
}

#[derive(ValueEnum, Clone, Serialize, Deserialize)]
enum Software {
    Paper,
    Folia,
    Purpur,
    Velocity,
}

#[derive(Serialize, Deserialize)]
struct Config {
    software: Software,
    minecraft_version: String,
    eula_accepted: bool,
}

fn inquired<T>(binding: Result<T, inquire::InquireError>) -> T {
    match binding {
        Ok(t) => t,
        Err(e) => {
            println!("{}: failed to inquire ({:?})", "error".red().bold(), e);
            exit(-1);
        }
    }
}

impl Software {
    fn from_name(name: String) -> Self {
        match name.as_str() {
            "paper" => Self::Paper,
            "folia" => Self::Folia,
            "purpur" => Self::Purpur,
            "velocity" => Self::Velocity,
            _ => panic!("Invalid software name: {}", name),
        }
    }

    fn name(&self) -> String {
        match self {
            Self::Paper => "paper",
            Self::Folia => "folia",
            Self::Purpur => "purpur",
            Self::Velocity => "velocity",
        }
        .to_string()
    }
}

impl Config {
    fn load() -> Result<Self, Box<dyn std::error::Error>> {
        if !Path::new(CONFIG_FILE).exists() {
            return Err("No config file found. Please run 'mcsast setup' first.".into());
        }

        let content = fs::read_to_string(CONFIG_FILE)?;
        let config: Config = serde_json::from_str(&content)?;
        Ok(config)
    }

    fn save(&self) -> Result<(), Box<dyn std::error::Error>> {
        let content = serde_json::to_string_pretty(self)?;
        fs::write(CONFIG_FILE, content)?;
        Ok(())
    }
}

fn handle_setup(
    software: Option<Software>,
    mc_version: Option<String>,
    eula: Option<bool>,
    yes: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let software = {
        if software.is_none() {
            let binding = Select::new(
                "💽 Which server software are you using?",
                vec!["Paper", "Folia", "Purpur", "Velocity"],
            )
            .prompt();

            Software::from_name(inquired(binding).to_lowercase().to_string())
        } else {
            software.unwrap()
        }
    };

    let version = {
        if software.name() == "velocity" {
            "3.4.0-SNAPSHOT".to_string()
        } else if mc_version.is_none() {
            let binding = Text::new("🪨  What version of Minecraft are you using?")
                .with_default("1.21.1")
                .prompt();

            inquired::<String>(binding)
        } else {
            mc_version.unwrap()
        }
    };

    let eula = {
        if software.name() == "velocity" {
            false
        } else if eula.is_none() {
            let binding = Confirm::new(
                format!(
                    "📄 Do you agree to the {}?",
                    "\x1B]8;;https://www.minecraft.net/en-us/eula\x1B\\Mojang EULA\x1B]8;;\x1B\\"
                        .purple()
                )
                .as_str(),
            )
            .with_placeholder("Y/n")
            .prompt();

            inquired::<bool>(binding)
        } else {
            eula.unwrap()
        }
    };

    if software.name() != "velocity" {
        println!(
            "\n✨ I will setup {}, with Minecraft server version {}, {} Mojang's EULA in this directory {}{}{}.",
            software.name().bold().yellow(),
            version.bold().blue(),
            {
                if eula {
                    "accepting".bold().green()
                } else {
                    "denying".bold().red()
                }
            },
            "(".dimmed(),
            {
                let current_dir = std::env::current_dir().unwrap();
                current_dir
                    .file_name()
                    .and_then(|name| name.to_str())
                    .unwrap_or("<unknown>")
                    .to_string()
            }
            .dimmed(),
            ")".dimmed()
        );
    } else {
        println!(
            "\n✨ I will setup {} in this directory {}{}{}.",
            software.name().bold().yellow(),
            "(".dimmed(),
            {
                let current_dir = std::env::current_dir().unwrap();
                current_dir
                    .file_name()
                    .and_then(|name| name.to_str())
                    .unwrap_or("<unknown>")
                    .to_string()
            }
            .dimmed(),
            ")".dimmed()
        );
    }

    if !yes {
        match Confirm::new("Proceed?").with_default(true).prompt() {
            Ok(result) => {
                if !result {
                    println!(
                        "\n🎏 You can pass `setup --software={} --mc-version={} --eula={}` to get everything up and running!\n",
                        software.name().bold().yellow(),
                        version.bold().blue(),
                        {
                            if eula {
                                "true".bold().green()
                            } else {
                                "false".bold().red()
                            }
                        }
                    );
                    println!("{}: aborted", "warning".yellow().bold());
                    exit(-1);
                }
            }
            Err(e) => {
                println!("{}: failed to inquire ({:?})", "error".red().bold(), e);
                exit(-1);
            }
        }
    }

    println!();

    if eula && software.name() != "velocity" {
        print!("(1/3) Adding EULA... ");
        match eula::add_eula() {
            Err(e) => {
                println!("{}: failed to add EULA ({:?})", "error".red().bold(), e);
                exit(-1);
            }
            Ok(_) => println!("{}", "✅ done!".bold().green()),
        }
    }

    print!(
        "{}Downloading {}... ",
        {
            if eula && software.name() != "velocity" {
                "(2/3) "
            } else {
                "(1/2) "
            }
        },
        software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match softwares::get(software.name(), version.clone()) {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    print!("{}Saving configuration... ", {
        if eula && software.name() != "velocity" {
            "(3/3) "
        } else {
            "(2/2) "
        }
    });

    let config = Config {
        software: software.clone(),
        minecraft_version: version.clone(),
        eula_accepted: eula,
    };

    match config.save() {
        Err(e) => {
            println!();
            println!("{}: failed to save config ({:?})", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    if eula && software.name() != "velocity" {
        println!("  {} eula.txt", "+".green().bold());
    }

    println!(
        "  {} server.jar {}{}{}",
        "+".green().bold(),
        "(".dimmed(),
        software.name().dimmed(),
        ")".dimmed()
    );

    println!("  {} {}", "+".green().bold(), CONFIG_FILE);

    Ok(())
}

fn handle_update() -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::load()?;

    println!(
        "🔄 Updating {}-{} to latest build...",
        config.software.name().bold().yellow(),
        config.minecraft_version.bold().blue()
    );

    print!(
        "(1/1) Downloading latest {}... ",
        config.software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match softwares::get(config.software.name(), config.minecraft_version.clone()) {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    println!(
        "  {} server.jar {}",
        "↻".green().bold(),
        "(updated to latest build}".dimmed()
    );

    Ok(())
}

fn handle_upgrade(target_version: Option<String>) -> Result<(), Box<dyn std::error::Error>> {
    let mut config = Config::load()?;

    let target_version = {
        if target_version.is_none() {
            if config.software.name() == "velocity" {
                eprintln!("❌ Velocity upgrades are currently unsupported.");
                return Err("Velocity upgrades are not supported".into());
            } else {
                let binding =
                    Text::new("🚀 What version of Minecraft would you like to upgrade to?")
                        .with_placeholder("e.g., 1.21.1")
                        .prompt();

                inquired::<String>(binding)
            }
        } else {
            target_version.unwrap()
        }
    };

    println!(
        "⬆️  Upgrading {} from version {} to {}...",
        config.software.name().bold().yellow(),
        config.minecraft_version.bold().blue(),
        target_version.bold().green()
    );

    print!(
        "(1/2) Downloading {}... ",
        config.software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match softwares::get(config.software.name(), target_version.clone()) {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    config.minecraft_version = target_version.clone();

    print!("(2/2) Updating configuration... ");
    match config.save() {
        Err(e) => {
            println!();
            println!(
                "{}: failed to update config ({:?})",
                "error".bold().red(),
                e
            );
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    println!(
        "  {} server.jar {} {}{}",
        "↗".green().bold(),
        "(upgraded to".dimmed(),
        target_version.dimmed(),
        ")".dimmed()
    );
    println!(
        "  {} {} {}",
        "↻".green().bold(),
        CONFIG_FILE,
        "(updated)".dimmed()
    );

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = CLI::parse();

    match cli.command {
        Commands::Setup {
            software,
            mc_version,
            eula,
            yes,
        } => handle_setup(software, mc_version, eula, yes),
        Commands::Update => handle_update(),
        Commands::Upgrade { version } => handle_upgrade(version),
    }
}
