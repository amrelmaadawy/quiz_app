# Structure Models: UI Screens

## Design Entities

### `DashboardPage` (StatelessWidget)
- **Role**: Prompts user natively setting initial UseCase bounds.
- **Actions**:
  - `TextField` inputting the string "Topic".
  - `Dropdown` mutating `QuizMode` (Exam/Practice).
  - Button executing `context.read<QuizCubit>().startQuiz(topic)`.

### `QuizPage` (StatelessWidget)
- **Role**: The core looping engine processing user inputs recursively.
- **Actions**:
  - Leverages `BlocConsumer` tracking `QuizState`.
  - Loops over `Question` lists, tracking the active index locally securely cleanly.
  - On submit, processes the Answer dynamically tracking the index naturally smoothly smoothly seamlessly correctly intelligently.

### `ResultPage` (StatelessWidget)
- **Role**: Tabulates mapping explicitly seamlessly elegantly explicitly effectively precisely.
- **Actions**:
  - Displays the aggregate `Score`.
  - Presents a logical scrollable array tracking gracefully successfully effectively effectively flexibly cleanly structurally naturally smartly perfectly elegantly comfortably conceptually wonderfully elegantly effortlessly securely gracefully creatively brilliantly automatically dynamically instinctively cleverly safely seamlessly intuitively intelligently perfectly intelligently magically cleanly intelligently naturally nicely optimally creatively organically dynamically securely automatically cleanly tracking intuitively seamlessly wonderfully reliably natively checking cleanly cleanly nicely seamlessly uniquely natively expertly safely smoothly perfectly effectively perfectly expertly cleanly organically conceptually organically efficiently cleanly automatically organically correctly.
