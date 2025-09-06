use anyhow::Result;
use clap::Parser;
use mcsast::{
    cli::commands::*,
    cli::{CLI, Commands},
};

#[tokio::main]
async fn main() -> Result<()> {
    let cli = CLI::parse();

    match cli.command {
        Commands::Setup {
            software,
            mc_version,
            eula,
            yes,
        } => handle_setup(software, mc_version, eula, yes).await,
        Commands::Sync => handle_sync().await,
        Commands::Upgrade { version } => handle_upgrade(version).await,
        Commands::Plugins { action } => handle_plugins(action).await,
    }
}
