CREATE TABLE local.acrl_parameters AS
SELECT
    /* Choose a start and end date for the loans period */
    '2000-01-01' :: DATE AS start_date,
    '2021-01-01' :: DATE AS end_date,
    /* Fill in a material type name, or leave blank for all types */
    '' :: VARCHAR AS material_type_filter,
    /* Fill in a location name, or leave blank for all locations */
    '' :: VARCHAR AS items_permanent_location_filter, --Online, Annex, Main Library
    '' :: VARCHAR AS items_temporary_location_filter, --Online, Annex, Main Library
    '' :: VARCHAR AS items_effective_location_filter, --Online, Annex, Main Library
    '' :: VARCHAR AS institution_filter, -- 'KÃ¸benhavns Universitet','Montoya College'
    '' :: VARCHAR AS campus_filter, -- 'Main Campus','City Campus','Online'
    '' :: VARCHAR AS library_filter -- 'Datalogisk Institut','Adelaide Library';
