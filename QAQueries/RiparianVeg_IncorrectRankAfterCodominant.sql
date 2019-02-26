SELECT		cd.SiteCode,
			cd.VisitDate
FROM		(	
			SELECT		rv.ID AS RiparianVegActivityID,
						s.Code AS SiteCode,
						v.VisitDate,
						ro.Rank,
						COUNT(ro.Rank) AS RankCount
			FROM		data.RiparianVegetationActivity AS rv
						INNER JOIN data.RiparianVegetationObservation AS ro
						ON ro.RiparianVegetationActivityID = rv.ID
						INNER JOIN data.Visit AS v
						ON rv.VisitID = v.ID
						INNER JOIN data.Site AS s
						ON v.SiteID = s.ID
						INNER JOIN lookup.LifeForm AS lf
						ON ro.LifeFormID = lf.ID
	
			GROUP BY	rv.ID, s.Code, v.VisitDate, ro.Rank
			HAVING		COUNT(ro.Rank) > 1
			) AS cd
			INNER JOIN data.RiparianVegetationObservation AS ro
			ON (cd.RiparianVegActivityID = ro.RiparianVegetationActivityID) AND ((ro.Rank > cd.Rank) AND (ro.Rank < (cd.Rank + cd.RankCount)))