cd /Users/GilbertJ/Documents/eLife_stats


sqlite3 paper_stats_test3.sqlite

SELECT i.ms,i.initial_qc_dt,i.initial_decision,i.initial_decision_dt,
f.full_qc_dt,f.full_decision,f.full_decision_dt,
r1.rev1_qc_dt,r1.rev1_decision,r1.rev1_decision_dt,
r2.rev2_qc_dt,r2.rev2_decision,r2.rev2_decision_dt,
r3.rev3_qc_dt,r3.rev3_decision,r3.rev3_decision_dt,
p.poa_dt,p.vor_dt

FROM initial i

LEFT JOIN full f
ON i.ms=f.ms

LEFT JOIN rev1 r1
ON i.ms=r1.ms

LEFT JOIN rev2 r2
ON i.ms=r2.ms

LEFT JOIN rev3 r3
ON i.ms=r3.ms

LEFT JOIN published p
ON i.ms=p.ms

ORDER BY i.ms;

.quit

exit
