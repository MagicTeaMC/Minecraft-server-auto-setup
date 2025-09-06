use clap::Parser;
use mcsast::{cli::{CLI, Commands}, cli::commands::*};

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
        Commands::Plugins { action } => {
            let rt = tokio::runtime::Runtime::new()?;
            rt.block_on(handle_plugins(action))
        }
    }
}
