import sys

with open('lib/app/modules/foodgrid/fooddetails/views/fooddetails_view.dart', 'r') as f:
    content = f.read()

# Fix 1: Lines 284, 285
bad_snippet = '''                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
              SliverFillRemaining('''
good_snippet = '''                        const SizedBox(height: 16),
                      ],
                    ),
              ),
              SliverFillRemaining('''
content = content.replace(bad_snippet, good_snippet)

# Fix 2: End of CustomScrollView
bad_snippet2 = '''                      ),
                    ],
                  ),
                ),
          // Floating Pinned Buttons'''
good_snippet2 = '''                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating Pinned Buttons'''
content = content.replace(bad_snippet2, good_snippet2)

with open('lib/app/modules/foodgrid/fooddetails/views/fooddetails_view.dart', 'w') as f:
    f.write(content)
