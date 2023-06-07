
# Nav component

navigation_styles <- list(
  root = list(
    height = "100%",
    boxSizing = "border-box",
    border = "1px solid #eee",
    overflowY = "auto"
  )
)

plot_link = list(
  list(
    name = "Label",
    key = "key1",
    target = "_blank"
  )
)

link_groups <- list(
  list(
    links = list(
      list(
        name = "Plot",
        expandAriaLabel = "Expand Plot section",
        collapseAriaLabel = "Collapse Plot section",
        links = plot_link,
        isExpanded = TRUE
      ),
      list(
        name = "Tutorial",
        url = "http://example.com",
        key = "tutorial",
        isExpanded = TRUE
      ),
      list(
        name = "News",
        url = "http://cnn.com",
        icon = "News",
        key = "key7",
        target = "_blank",
        iconProps = list(
          iconName = "News",
          styles = list(
            root = list(
              fontSize = 20,
              color = "#106ebe"
            )
          )
        )
      )
    )
  )
)

