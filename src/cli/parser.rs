use crate::core::Software;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(
    version = "2.3.0",
    author = "Maoyue (MagicTeaMC)",
    about = "Manage Minecraft server / proxy / plugins quickly and easily!"
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
    /// sync to latest build of this version
    Sync,
    /// upgrade to another version
    Upgrade {
        /// your target minecraft version
        #[arg(short, long)]
        version: Option<String>,
    },
    /// manage plugins
    Plugins {
        #[command(subcommand)]
        action: PluginActions,
    },
}

#[derive(Subcommand)]
pub enum PluginActions {
    /// list installed plugins
    List,
    /// download and install a plugin
    Add {
        /// plugin name or project ID
        name: String,
        /// force install even if incompatible
        #[arg(short, long, default_value_t = false)]
        force: bool,
    },
    /// load plugins from config file
    Load {
        /// config file path
        config: String,
    },
    /// update plugins
    Update {
        /// plugin name or 'all' for all plugins
        target: String,
        /// include beta/alpha versions
        #[arg(short, long, default_value_t = false)]
        force: bool,
    },
    /// remove a plugin
    Remove {
        /// plugin name
        name: String,
    },
    /// search for plugins
    Search {
        /// search query
        query: String,
        /// number of results to show
        #[arg(short, long, default_value_t = 10)]
        limit: u32,
    },
    /// show plugin information
    Info {
        /// plugin name or project ID
        name: String,
    },
    /// export current plugins to config file
    Export {
        /// output file path
        #[arg(short, long, default_value = "plugins.json")]
        output: String,
    },
}
