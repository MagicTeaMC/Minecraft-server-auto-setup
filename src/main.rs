use std::{io::Write, process::exit};

use clap::{Parser, ValueEnum};
use colored::Colorize;
use inquire::{Confirm, Select, Text};

mod eula;
mod softwares;

#[derive(Parser)]
#[command(
    version = "2.0.0-SNAPSHOT",
    author = "Maoyue (MagicTeaMC)",
    about = "Minecraft server auto setup tool, simplified!"
)]
struct CLI {
    /// Software to use (paper/folia/purpur)
    #[arg(short, long, value_enum)]
    software: Option<Software>,

    /// Minecraft version (e.g., 1.21.1)
    #[arg(short, long)]
    mc_version: Option<String>,

    /// EULA agreement (true/false), reference: www.minecraft.net/en-us/eula
    #[arg(short, long)]
    eula: Option<bool>,

    /// Skip confirmation prompt?
    #[arg(short, default_value_t = false)]
    yes: bool,
}

#[derive(ValueEnum, Clone)]
enum Software {
    Paper,
    Folia,
    Purpur,
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
            _ => panic!("Invalid software name: {}", name),
        }
    }

    fn name(&self) -> String {
        match self {
            Self::Paper => "paper",
            Self::Folia => "folia",
            Self::Purpur => "purpur",
        }
        .to_string()
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = CLI::parse();

    println!(
        r#"
░▒▓██████████████▓▒░ ░▒▓██████▓▒░ ░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░▒▓████████▓▒░ 
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░   ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░  ░▒▓█▓▒░     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░   ░▒▓█▓▒░

                              {}                                
"#,
        "By Maoyue (MagicTeaMC)".yellow()
    );

    let software = {
        if cli.software.is_none() {
            let binding = Select::new(
                "💽 What server software are you using?",
                vec!["paper", "folia", "purpur"],
            )
            .prompt();

            Software::from_name(inquired(binding).to_string())
        } else {
            cli.software.unwrap()
        }
    };
    let version = {
        if cli.mc_version.is_none() {
            let binding = Text::new("🪨  What version of Minecraft are you using?")
                .with_default("1.21.1")
                .prompt();

            inquired::<String>(binding)
        } else {
            cli.mc_version.unwrap()
        }
    };
    let eula = {
        if cli.eula.is_none() {
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
            cli.eula.unwrap()
        }
    };

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
                .to_owned()
                .file_name()
                .and_then(|name| name.to_str())
                .unwrap_or("<unknown>")
        }.dimmed(),
        ")".dimmed()
    );

    if !cli.yes {
        match Confirm::new("Proceed?").with_default(true).prompt() {
            Ok(result) => {
                if !result {
                    println!(
                    "\n🎏 You can pass `--software={} --mc-version={} --eula={}` to get everything up and running!\n",
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

    if eula {
        print!("(1/2) Adding EULA... ");
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
            if eula {
                "(2/2) "
            } else {
                "(1/1) "
            }
        },
        software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match softwares::get(software.name(), version) {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    if eula {
        println!("  {} eula.txt", "+".green().bold());
    }

    println!(
        "  {} server.jar {}{}{}",
        "+".green().bold(),
        "(".dimmed(),
        software.name().dimmed(),
        ")".dimmed()
    );

    Ok(())
}