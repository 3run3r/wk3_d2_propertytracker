DROP TABLE IF EXISTS properties;

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  value VARCHAR(255),
  number_of_bedrooms INT,
  build VARCHAR(255),
  buy_let_status VARCHAR(255)
);
