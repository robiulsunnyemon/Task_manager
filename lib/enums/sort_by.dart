enum SortBy {
  deadline,
  priority,
  title;

  String get label {
    switch (this) {
      case SortBy.deadline:
        return 'Deadline';
      case SortBy.priority:
        return 'Priority';
      case SortBy.title:
        return 'Title';
    }
  }
}