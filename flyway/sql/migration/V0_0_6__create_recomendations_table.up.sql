 CREATE TABLE IF NOT EXISTS marketplace.recomendationsPosts (
    id SERIAL PRIMARY KEY,
    user_id uuid,
    post_id INTEGER,
    rating float4,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 CREATE TABLE IF NOT EXISTS marketplace.recomendationsModels (
    id SERIAL PRIMARY KEY,
    user_id uuid,
    model_id INTEGER,
    rating float4,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 CREATE TABLE IF NOT EXISTS marketplace.recomendationsts (
    id SERIAL PRIMARY KEY,
    user_id uuid,
    ts_id uuid,
    rating float4,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);