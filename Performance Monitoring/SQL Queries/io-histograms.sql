-- I/O Histograms 
SELECT INST_ID,
                            EVENT,
                            WAIT_TIME_MILLI,
                            WAIT_COUNT
                            FROM sys.GV_$EVENT_HISTOGRAM
                            where event in ('db file sequential read',
                  'db file scattered read',
                  'direct path read',
                  'direct path read temp',
                  'direct path write',
                  'direct path write temp',
                  'log file sync',
                  'log file parallel write','cell single block physical read','cell list of blocks physical read','cell multiblock physical read')
