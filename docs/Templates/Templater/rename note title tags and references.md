<%*
  let title = tp.file.title
  if (title.startsWith("Untitled")) {
    title = await tp.system.prompt("Title");
    await tp.file.rename(`${title}`);
  } 
  tR += "---"
%>

# rename note title tags and references
---
tags: Note <%tp.file.creation_date("YYYY")%>
---

<% tp.file.cursor() %>

___

## References:
- 

---
creation date:: [[<%tp.file.creation_date("YYYY-MM-DD")%>]] <%tp.file.creation_date("HH:mm")%>