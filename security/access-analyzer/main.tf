resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = var.analyzer_name
  type          = var.analyzer_type
  tags          = var.tags
}

resource "aws_accessanalyzer_archive_rule" "this" {
  for_each = { for rule in var.archive_rules : rule.rule_name => rule }

  analyzer_name = aws_accessanalyzer_analyzer.this.analyzer_name
  rule_name     = each.key

  dynamic "filter" {
    for_each = each.value.filter
    content {
      criteria = filter.value.criteria
      eq       = length(filter.value.eq) > 0 ? filter.value.eq : null
      neq      = length(filter.value.neq) > 0 ? filter.value.neq : null
      exists   = filter.value.exists
    }
  }
}
