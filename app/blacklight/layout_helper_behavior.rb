# frozen_string_literal: true

# Overrides the methods in Blacklight::LayoutHelperBehavior
module LayoutHelperBehavior
  ##
  # Classes added to a document's show content div
  # @return [String]
  def show_content_classes
    'col-sm-8 col-md-9 show-document'
  end

  ##
  # Classes added to a document's sidebar div
  # @return [String]
  def show_sidebar_classes
    'col-sm-4 col-md-3'
  end

  ##
  # Classes used for sizing the main content of a Blacklight page
  # @return [String]
  def main_content_classes
    'col-sm-8 col-sm-push-4 col-md-9 col-md-push-3'
  end

  ##
  # Classes used for sizing the sidebar content of a Blacklight page
  # @return [String]
  def sidebar_classes
    'col-sm-4 col-sm-pull-8 col-md-3 col-md-pull-9'
  end
end
