use clap::ValueEnum;
use serde::{Deserialize, Serialize};

#[derive(ValueEnum, Clone, Serialize, Deserialize)]
pub enum Software {
    Paper,
    Folia,
    Purpur,
    Velocity,
    Gate,
    Nukkit,
    Geyser,
}

impl Software {
    pub fn from_name(name: String) -> Self {
        match name.as_str() {
            "paper" => Self::Paper,
            "folia" => Self::Folia,
            "purpur" => Self::Purpur,
            "velocity" => Self::Velocity,
            "gate" => Self::Gate,
            "nukkit" => Self::Nukkit,
            "geyser" => Self::Geyser,
            _ => panic!("Invalid software name: {}", name),
        }
    }

    pub fn name(&self) -> String {
        match self {
            Self::Paper => "paper",
            Self::Folia => "folia",
            Self::Purpur => "purpur",
            Self::Velocity => "velocity",
            Self::Gate => "gate",
            Self::Nukkit => "nukkit",
            Self::Geyser => "geyser",
        }
        .to_string()
    }

    pub fn requires_eula(&self) -> bool {
        !matches!(
            self,
            Self::Velocity | Self::Gate | Self::Nukkit | Self::Geyser
        )
    }

    pub fn supports_minecraft_version(&self) -> bool {
        !matches!(self, Self::Gate | Self::Nukkit | Self::Geyser)
    }

    pub fn supports_upgrade(&self) -> bool {
        !matches!(
            self,
            Self::Velocity | Self::Gate | Self::Nukkit | Self::Geyser
        )
    }

    pub fn default_version(&self) -> String {
        match self {
            Self::Velocity => "3.4.0-SNAPSHOT".to_string(),
            Self::Gate | Self::Nukkit | Self::Geyser => "ignore".to_string(),
            _ => "1.21.1".to_string(),
        }
    }

    pub fn display_names() -> Vec<&'static str> {
        vec![
            "Paper", "Folia", "Purpur", "Velocity", "Gate", "Nukkit", "Geyser",
        ]
    }
}
