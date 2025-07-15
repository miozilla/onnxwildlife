-- CREATE OR REPLACE EXTERNAL TABLE
--   `onnx_demo.wildlife`
-- WITH CONNECTION `us-east1.onnx_conn`
-- OPTIONS (
--   object_metadata = 'SIMPLE',
--   uris = ['gs://<bucket>/<folder>/images/*']
--   );

-- LOAD DATA OVERWRITE onnx_demo.classifier
-- (ID INT64,Classification STRING)
-- FROM FILES (
--   format = 'CSV',
--   uris = ['gs://<bucket>/<folder>/classifier.csv']);


-- CREATE OR REPLACE MODEL `onnx_demo.model`
--  OPTIONS (MODEL_TYPE='ONNX',
--   MODEL_PATH='gs://<bucket>/<folder>/resnet18.onnx')


SELECT * FROM `<dataset>.onnx_demo.classifier`
WHERE EXISTS (
SELECT
   1
FROM
   ML.PREDICT(MODEL onnx_demo.model,
      (
      SELECT
      ML.RESIZE_IMAGE(ML.DECODE_IMAGE(DATA),
         224,
         224,
         FALSE) AS input
      FROM
         `onnx_demo.wildlife`
      )
   )
WHERE
   class_label = ID - 1
)
  

