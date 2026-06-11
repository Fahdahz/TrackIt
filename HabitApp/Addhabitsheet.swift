//
//  AddHabitSheet.swift
//  HabitApp
//

import SwiftUI
import UserNotifications

struct AddHabitSheet: View {
    @Environment(\.dismiss) private var dismiss

    // Callback to pass the new habit back to ContentView
    var onAdd: (Habit) -> Void

    @State private var habitName: String = ""
    @State private var amountPerDay: Int = 1
    @State private var targetDate: Date = Date()
    @State private var remindersOn: Bool = false
    @State private var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var showEmojiPicker: Bool = false
    @State private var selectedEmoji: String = ""
    @State private var showNotificationDeniedAlert: Bool = false

    // Edit mode support
    var editingHabit: Habit? = nil

    init(editingHabit: Habit? = nil, onAdd: @escaping (Habit) -> Void) {
        self.editingHabit = editingHabit
        self.onAdd = onAdd
        if let h = editingHabit {
            _habitName     = State(initialValue: h.name)
            _amountPerDay  = State(initialValue: h.amountPerDay)
            _targetDate    = State(initialValue: h.targetDate)
            _remindersOn   = State(initialValue: h.remindersOn)
            _selectedEmoji = State(initialValue: h.icon)
            if let savedTime = h.reminderTime {
                _reminderTime = State(initialValue: savedTime)
            }
        }
    }

    var body: some View {
        VStack(spacing: 24) {

            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            // Title
            Text(editingHabit == nil ? "New Habit" : "Edit Habit")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(.black)

            // Emoji picker button
            VStack(spacing: 8) {
                Button { showEmojiPicker = true } label: {
                    ZStack {
                        Circle()
                            .stroke(Color("PrimaryOrange"), lineWidth: 1.5)
                            .frame(width: 100, height: 100)
                            .background(Circle().fill(Color("PrimaryOrange").opacity(0.06)))

                        if selectedEmoji.isEmpty {
                            Image(systemName: "plus")
                                .font(.system(size: 32, weight: .regular))
                                .foregroundColor(Color("PrimaryOrange"))
                        } else {
                            Text(selectedEmoji).font(.system(size: 44))
                        }
                    }
                }
                Text("Add Habit Emoji")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            // Habit Name
            TextField("Habit Name", text: $habitName)
                .font(.system(size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 18)
                .padding(.vertical, 18)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color("BackgroundCream")))
                .padding(.horizontal, 24)

            // Amount per day + Target Date
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Amount per day")
                        .font(.system(size: 13))
                        .foregroundColor(.black)

                    HStack(spacing: 0) {
                        Button {
                            if amountPerDay > 1 { amountPerDay -= 1 }
                        } label: {
                            Text("−")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 36)
                        }
                        Divider().frame(height: 20)
                        Text("\(amountPerDay)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 36)
                        Divider().frame(height: 20)
                        Button { amountPerDay += 1 } label: {
                            Text("+")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 36)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color("BackgroundCream")))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Target Date")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    DatePicker("", selection: $targetDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .tint(Color("PrimaryOrange"))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color("BackgroundCream")))
            }
            .padding(.horizontal, 24)

            // Reminders
            VStack(spacing: 0) {
                HStack {
                    Text("Reminders")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Toggle("", isOn: $remindersOn)
                        .tint(Color("PrimaryOrange"))
                        .onChange(of: remindersOn) { _, newValue in
                            if newValue {
                                requestNotificationPermission()
                            }
                        }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 18)

                if remindersOn {
                    Divider()
                        .padding(.horizontal, 18)

                    HStack {
                        Text("Time")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                        Spacer()
                        DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .tint(Color("PrimaryOrange"))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                }
            }
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Color("BackgroundCream")))
            .padding(.horizontal, 24)

            Spacer()

            // Done button
            Button {
                guard !habitName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                var habit = Habit(
                    name: habitName,
                    icon: selectedEmoji.isEmpty ? "⭐️" : selectedEmoji,
                    amountPerDay: amountPerDay,
                    targetDate: targetDate,
                    remindersOn: remindersOn,
                    completed: editingHabit?.completed ?? 0,
                    isFrozen: editingHabit?.isFrozen ?? false
                )
                habit.reminderTime = remindersOn ? reminderTime : nil

                // Keep the same id when editing so store.update() finds it
                if let existing = editingHabit {
                    habit.id = existing.id
                }

                // Schedule or cancel the local notification
                if remindersOn {
                    scheduleReminder(for: habit)
                } else {
                    cancelReminder(for: habit)
                }

                onAdd(habit)
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color("PrimaryOrange")))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerView(selectedEmoji: $selectedEmoji)
                .presentationDetents([.medium])
        }
        .alert("Notifications Disabled", isPresented: $showNotificationDeniedAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {
                remindersOn = false
            }
        } message: {
            Text("To get reminders for this habit, please enable notifications in Settings.")
        }
    }

    // MARK: - Notification Helpers

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    break // already allowed, nothing to do
                case .notDetermined:
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                        DispatchQueue.main.async {
                            if !granted {
                                remindersOn = false
                            }
                        }
                    }
                case .denied:
                    showNotificationDeniedAlert = true
                @unknown default:
                    break
                }
            }
        }
    }

    private func scheduleReminder(for habit: Habit) {
        let center = UNUserNotificationCenter.current()
        let identifier = "habit-reminder-\(habit.id.uuidString)"

        // Remove any existing reminder for this habit before scheduling a new one
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        let content = UNMutableNotificationContent()
        content.title = "\(habit.icon) \(habit.name)"
        content.body = "Time to work on your habit: \(habit.name)"
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule reminder: \(error.localizedDescription)")
            }
        }
    }

    private func cancelReminder(for habit: Habit) {
        let identifier = "habit-reminder-\(habit.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

// MARK: - Emoji Picker

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String
    @Environment(\.dismiss) private var dismiss

    private let emojis = [
        "💧","🏃🏻‍♀️","📚","🧘","🍎","💊","🛌","✍️",
        "🎯","🏋️","🚴","🧹","💪","🌿","☀️","🎨",
        "🎵","🧠","💻","📝","🫀","🥗","🍵","🚶"
    ]

    var body: some View {
        VStack(spacing: 16) {
            Text("Choose Emoji")
                .font(.system(size: 18, weight: .semibold))
                .padding(.top, 16)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
                ForEach(emojis, id: \.self) { emoji in
                    Button {
                        selectedEmoji = emoji
                        dismiss()
                    } label: {
                        Text(emoji).font(.system(size: 32))
                    }
                }
            }
            .padding()
            Spacer()
        }
        .background(Color("BackgroundCream").ignoresSafeArea())
    }
}

#Preview {
    AddHabitSheet { _ in }
}
