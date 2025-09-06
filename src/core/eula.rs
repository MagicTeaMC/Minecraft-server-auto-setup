use std::{fs, io::Write};
use anyhow::Result;

pub fn add_eula() -> Result<()> {
    let mut file = fs::File::create("eula.txt")?;

    file.write_all("eula=true".as_bytes())?;
    Ok(())
}
