use serde::Deserialize;
use std::collections::HashMap;
use anyhow::Result;

#[derive(Deserialize, Debug, Clone)]
pub struct ModrinthVersion {
    pub id: String,
    pub project_id: String,
    pub name: String,
    pub version_number: String,
    pub game_versions: Vec<String>,
    pub loaders: Vec<String>,
    pub version_type: String,
    pub files: Vec<ModrinthFile>,
    pub date_published: String,
}

#[derive(Deserialize, Debug, Clone)]
pub struct ModrinthFile {
    pub url: String,
    pub filename: String,
    pub primary: bool,
    pub size: u64,
}

#[derive(Deserialize, Debug, Clone)]
pub struct ModrinthProject {
    #[serde(alias = "id")]
    pub project_id: String,
    pub slug: String,
    pub title: String,
    pub description: String,
    pub categories: Vec<String>,
    #[serde(default)]
    pub loaders: Vec<String>,
    #[serde(default)]
    pub game_versions: Vec<String>,
    pub downloads: u64,
    #[serde(alias = "followers")]
    pub follows: u64,
    pub project_type: String,
}

#[derive(Deserialize, Debug)]
pub struct ModrinthSearchResult {
    pub hits: Vec<ModrinthProject>,
    pub offset: u32,
    pub limit: u32,
    pub total_hits: u32,
}

pub struct ModrinthClient {
    client: reqwest::Client,
    base_url: String,
}

impl ModrinthClient {
    pub fn new() -> Self {
        Self {
            client: reqwest::Client::new(),
            base_url: "https://api.modrinth.com/v2".to_string(),
        }
    }

    pub async fn search_projects(
        &self,
        query: &str,
        limit: u32,
        loaders: &[String],
        game_versions: &[String],
    ) -> Result<ModrinthSearchResult> {
        let mut facets = vec![];

        if !loaders.is_empty() {
            let loader_facets = loaders
                .iter()
                .map(|l| format!("\"categories:{}\"", l))
                .collect::<Vec<_>>()
                .join(",");
            facets.push(format!("[{}]", loader_facets));
        }

        if !game_versions.is_empty() {
            let version_facets = game_versions
                .iter()
                .map(|v| format!("\"versions:{}\"", v))
                .collect::<Vec<_>>()
                .join(",");
            facets.push(format!("[{}]", version_facets));
        }

        let mut params = vec![("query", query.to_string()), ("limit", limit.to_string())];

        if !facets.is_empty() {
            params.push(("facets", format!("[{}]", facets.join(","))));
        }

        let url = format!("{}/search", self.base_url);
        let response = self.client.get(&url).query(&params).send().await?;

        if !response.status().is_success() {
            return Err(anyhow::anyhow!("Search request failed: {}", response.status()));
        }

        let result: ModrinthSearchResult = response.json().await?;
        Ok(result)
    }

    pub async fn get_project(
        &self,
        id_or_slug: &str,
    ) -> Result<ModrinthProject> {
        let url = format!("{}/project/{}", self.base_url, id_or_slug);
        let response = self.client.get(&url).send().await?;

        if !response.status().is_success() {
            return Err(anyhow::anyhow!("Project not found: {}", id_or_slug));
        }

        let project: ModrinthProject = response.json().await?;
        Ok(project)
    }

    pub async fn get_project_versions(
        &self,
        project_id: &str,
        game_versions: &[String],
        loaders: &[String],
        version_type: Option<&str>,
    ) -> Result<Vec<ModrinthVersion>> {
        let mut params = HashMap::new();

        if !game_versions.is_empty() {
            params.insert(
                "game_versions",
                format!("[\"{}\"]", game_versions.join("\",\"")),
            );
        }

        if !loaders.is_empty() {
            params.insert("loaders", format!("[\"{}\"]", loaders.join("\",\"")));
        }

        let url = format!("{}/project/{}/version", self.base_url, project_id);
        let response = self.client.get(&url).query(&params).send().await?;

        if !response.status().is_success() {
            return Err(anyhow::anyhow!("Failed to get versions for project: {}", project_id));
        }

        let mut versions: Vec<ModrinthVersion> = response.json().await?;

        // Filter by version type if specified
        if let Some(vtype) = version_type {
            versions.retain(|v| v.version_type == vtype);
        }

        // Sort by date (newest first)
        versions.sort_by(|a, b| b.date_published.cmp(&a.date_published));

        Ok(versions)
    }

    pub async fn download_file(
        &self,
        url: &str,
        path: &std::path::Path,
    ) -> Result<()> {
        let response = self.client.get(url).send().await?;

        if !response.status().is_success() {
            return Err(anyhow::anyhow!("Failed to download file: {}", response.status()));
        }

        let content = response.bytes().await?;
        std::fs::write(path, content)?;
        Ok(())
    }
}
