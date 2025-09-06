use anyhow::Result;
use crate::cli::PluginActions;
use crate::plugins;

pub async fn handle_plugins(action: PluginActions) -> Result<()> {
    match action {
        PluginActions::List => plugins::list_plugins().await,
        PluginActions::Add { name, force } => plugins::get_plugin(&name, force).await,
        PluginActions::Load { config } => plugins::load_plugins_from_config(&config).await,
        PluginActions::Update { target, force } => plugins::update_plugins(&target, force).await,
        PluginActions::Remove { name } => plugins::remove_plugin(&name).await,
        PluginActions::Search { query, limit } => plugins::search_plugins(&query, limit).await,
        PluginActions::Info { name } => plugins::show_plugin_info(&name).await,
        PluginActions::Export { output } => plugins::export_plugins_config(&output).await,
    }
}
