use std::{io::Write, process::exit};
use colored::Colorize;
use inquire::{Confirm, Select, Text};
use anyhow::Result;

use crate::core::{Config, Software, eula};
use crate::download;
use crate::utils::{get_current_directory_name, get_executable_extension, inquired, print_error_and_exit};

pub async fn handle_setup(
    software: Option<Software>,
    mc_version: Option<String>,
    eula: Option<bool>,
    yes: bool,
) -> Result<()> {
    let software = {
        if software.is_none() {
            let binding = Select::new(
                "💽 Which server software are you using?",
                Software::display_names(),
            )
            .prompt();

            Software::from_name(inquired(binding).to_lowercase().to_string())
        } else {
            software.unwrap()
        }
    };

    let version = {
        if !software.supports_minecraft_version() {
            software.default_version()
        } else if software.name() == "velocity" {
            "3.4.0-SNAPSHOT".to_string()
        } else if mc_version.is_none() {
            let binding = Text::new("🪨  What version of Minecraft are you using?")
                .with_default(&software.default_version())
                .prompt();

            inquired::<String>(binding)
        } else {
            mc_version.unwrap()
        }
    };

    let eula = {
        if !software.requires_eula() {
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

    if software.requires_eula() {
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
            get_current_directory_name().dimmed(),
            ")".dimmed()
        );
    } else {
        println!(
            "\n✨ I will setup {} in this directory {}{}{}.",
            software.name().bold().yellow(),
            "(".dimmed(),
            get_current_directory_name().dimmed(),
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
            Err(e) => print_error_and_exit("failed to inquire", e),
        }
    }

    println!();

    if eula && software.requires_eula() {
        print!("(1/3) Adding EULA... ");
        match eula::add_eula() {
            Err(e) => print_error_and_exit("failed to add EULA", e),
            Ok(_) => println!("{}", "✅ done!".bold().green()),
        }
    }

    print!(
        "{}Downloading {}... ",
        {
            if eula && software.requires_eula() {
                "(2/3) "
            } else {
                "(1/2) "
            }
        },
        software.name().cyan().bold()
    );
    std::io::stdout().flush()?;

    match download::get(&software.name(), version.clone()).await {
        Err(e) => {
            println!();
            println!("{}: {}", "error".bold().red(), e);
            exit(-1);
        }
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    print!("{}Saving configuration... ", {
        if eula && software.requires_eula() {
            "(3/3) "
        } else {
            "(2/2) "
        }
    });

    let config = Config {
        software: software.clone(),
        minecraft_version: version.clone(),
        eula_accepted: eula,
        plugins: Vec::new(),
    };

    match config.save() {
        Err(e) => print_error_and_exit("failed to save config", e),
        Ok(_) => println!("{}", "✅ done!".bold().green()),
    }

    println!("\n{}", "Summary".bold().underline());
    if eula && software.requires_eula() {
        println!("  {} eula.txt", "+".green().bold());
    }

    let need_exe = get_executable_extension();

    if software.name() == "gate" {
        println!(
            "  {} gate{} {}{}{}",
            "+".green().bold(),
            need_exe,
            "(".dimmed(),
            software.name().dimmed(),
            ")".dimmed()
        );
    } else {
        println!(
            "  {} server.jar {}{}{}",
            "+".green().bold(),
            "(".dimmed(),
            software.name().dimmed(),
            ")".dimmed()
        );
    }

    println!("  {} {}", "+".green().bold(), Config::config_file());

    Ok(())
}
