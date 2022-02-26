SELECT posts.id,
                   posts.title,
                   CASE
          WHEN Bit_length(posts.body) > 500 THEN Substring(posts.body FROM 1
          FOR 500)
          || '...'
          ELSE posts.body
        end           AS body,
                         posts.created_at,
                         Count(c.body) AS comments_count
        FROM   posts
        LEFT JOIN comments c
        ON posts.id = c.post_id
        GROUP  BY posts.id
        ORDER  BY created_at DESC