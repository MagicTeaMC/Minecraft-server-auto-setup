use anyhow::Result;
use std::{fs, io::Write};

pub fn add_eula() -> Result<()> {
    let mut file = fs::File::create("eula.txt")?;

    file.write_all("eula=true".as_bytes())?;
    Ok(())
}
