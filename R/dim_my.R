#' dim_my
#'
#' A function for analysis the milk yield of the herd.
#' @keywords dairy cattle milk yield days-in-milk
#' @import ggplot2
#' @import dplyr
#' @import viridis
#' @export
#' @examples
#' dim_my(data = dairyCattle::read_cattle("cattle_data.xls", drop.zero = TRUE, add = TRUE), grid = FALSE, density = FALSE, line = FALSE, text = FALSE)

dim_my <- function(data, grid = FALSE, density = FALSE, line = FALSE, text = FALSE) {
  
  # plot ----
  plot <- data %>%
    ggplot(aes(x = 누적착유일수, y = 유량, color = parity))

  if (density == TRUE) {
    plot <- plot +
      stat_density2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
      viridis::scale_fill_viridis(option = "E")
  }

  if (grid == TRUE) {
    plot <- plot +
      facet_grid(parity ~ .) +
      theme(strip.background = element_rect(fill = "black"))
  }

  if (line == TRUE) {
    # model 1 ----
    model <- lm(유량 ~ 누적착유일수 + I(누적착유일수^2), data)
    xmin <- min(data$누적착유일수)
    xmax <- max(data$누적착유일수)
    predicted <- data.frame(누적착유일수 = seq(xmin, xmax, length.out = 100))
    predicted$유량 <- predict(model, predicted)
    
    # model 65 to 305 ----
    data1 <- filter(data, 누적착유일수 > 65, 누적착유일수 < 305)
    model_65_305 <- lm(유량 ~ 누적착유일수, data1)
    xmin <- 65
    
    # xmax <- 305
    predicted_65_305 <- data.frame(누적착유일수 = seq(xmin, xmax, length.out = 100))
    predicted_65_305$유량 <- predict(model_65_305, predicted)
    
    plot <- plot +
      geom_vline(xintercept = 305, color = "grey", linetype = "dashed") +
      geom_vline(xintercept = 220 + median(data$공태일수), color = "grey") +
      geom_vline(xintercept = 65, color = "grey") +
      geom_hline(yintercept = mean(data$유량), color = "grey") +
      geom_hline(yintercept = median(data$유량), color = "grey", linetype = "dashed") +
      geom_line(data = predicted, size = 0.5, color = "light green") +
      geom_line(data = predicted_65_305, size = 0.5, color = "pink")
  }

  if (text == TRUE) {
    plot <- plot +
      geom_text(aes(y = 유량, label = 단축명호), size = 2, hjust = 1.3)
  }

  plot <- plot +
    geom_point(aes(shape = parity)) +
    scale_shape_manual(values = c(1, 19)) +
    geom_rug() +
    theme_linedraw(base_family = "NanumGothic") +
    # scale_x_continuous(breaks = seq(0, 400, 50)) +
    labs(x = "Days in milk, d", y = "Milk yield, kg")

  return(plot)
}

