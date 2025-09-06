pub mod setup;
pub mod sync;
pub mod upgrade;
pub mod plugins;

pub use setup::handle_setup;
pub use sync::handle_sync;
pub use upgrade::handle_upgrade;
pub use plugins::handle_plugins;
