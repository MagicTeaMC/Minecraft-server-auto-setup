use std::{fs, io::Write};

pub fn add_eula() -> Result<(), Box<dyn std::error::Error>> {
    let mut file = fs::File::create("eula.txt")?;

    file.write_all("eula=true".as_bytes())?;
    Ok(())
}
