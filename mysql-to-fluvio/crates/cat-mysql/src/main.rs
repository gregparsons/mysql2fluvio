//!
//! main.rs
//!
//!
use serde::Deserialize;
use sqlx::mysql::MySqlPoolOptions;

/// Continuously add cat facts to the database to simulate database events.
/// dependencies: sqlx, reqwest, mysql, serde, serde_json
async fn load_cats_forever() -> Result<(), sqlx::Error> {

    let pool = MySqlPoolOptions::new()
        .max_connections(5)
        .connect("mysql://mysqluser:vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A@localhost:3306/cat")
        .await?;

    #[derive(Deserialize)]
    struct CatFact { fact: String }

    loop {
        let body = reqwest::get("https://catfact.ninja/fact").await.unwrap().text().await.unwrap();
        let cat_fact: CatFact = serde_json::from_str(&body).unwrap();
        println!("fact: {}", &cat_fact.fact);
        let _ = sqlx::query("insert into cat.facts (fact, dt) values (?, now())").bind(&cat_fact.fact).execute(&pool).await.unwrap();

        tokio::time::sleep(tokio::time::Duration::from_millis(1000)).await;

    }
}


fn main() {

    // this is the tokio runtime (normally in the tokio main macro)
    let _ = tokio::runtime::Builder::new_multi_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(async {

            tokio::spawn(async { load_cats_forever().await });

            println!("done spawning long-running thread");

            // parent and all children die after 50 sec
            let mut child = std::process::Command::new("sleep").arg("200").spawn().unwrap();
            let _result = child.wait().unwrap();
        });


}
