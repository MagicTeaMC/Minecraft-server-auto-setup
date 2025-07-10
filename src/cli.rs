use crate::software::Software;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(
    version = "2.2.2",
    author = "Maoyue (MagicTeaMC)",
    about = "Manage Minecraft server / proxy quickly and easily!"
)]
pub struct CLI {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// initial setup
    Setup {
        /// software to use (paper/folia/purpur/velocity/gate/nukkit/geyser)
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
