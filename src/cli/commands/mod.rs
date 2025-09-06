pub mod setup;
pub mod update;
pub mod upgrade;
pub mod plugins;

pub use setup::handle_setup;
pub use update::handle_update;
pub use upgrade::handle_upgrade;
pub use plugins::handle_plugins;
