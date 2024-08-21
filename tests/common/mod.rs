use color_eyre::Result;
use testcontainers_modules::{
    postgres::Postgres,
    redis::Redis,
    testcontainers::{runners::AsyncRunner, ContainerAsync, ImageExt, TestcontainersError},
};

pub async fn setup() -> Result<()> {
    integration_tests::dummy().await;
    Ok(())
}
