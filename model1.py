from flask import Flask, request, jsonify
import cv2
import mediapipe as mp
import numpy as np

# Initialize Flask app
app = Flask(__name__)

# Initialize MediaPipe Pose and Hand Tracking
mp_pose = mp.solutions.pose
mp_hands = mp.solutions.hands

pose = mp_pose.Pose(
    static_image_mode=False,
    model_complexity=2,
    enable_segmentation=False,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)

hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=2,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5
)

# Constants
POSITION_TOLERANCE = 0.25


# Single integrated function to process real-time pose comparison
def compare_pose_with_video(video_path):
    cap_video = cv2.VideoCapture(video_path)  # Open the reference video
    cap_webcam = cv2.VideoCapture(0)          # Open the webcam

    if not cap_video.isOpened() or not cap_webcam.isOpened():
        return {"error": "Could not open video or webcam."}

    feedback_message = "Waiting for pose..."
    feedback_color = (255, 255, 255)
    pause_video = False  # Flag to track if video is paused

    try:
        while cap_video.isOpened() and cap_webcam.isOpened():
            if not pause_video:
                ret_video, frame_video = cap_video.read()
            ret_webcam, frame_webcam = cap_webcam.read()

            if not ret_video or not ret_webcam:
                print("End of video or webcam feed.")
                break

            # Resize video to match webcam frame size
            frame_video_resized = cv2.resize(frame_video, (frame_webcam.shape[1], frame_webcam.shape[0]))

            # Process hand landmarks
            def get_normalized_hand_landmarks(frame):
                image_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                results = hands.process(image_rgb)

                if results.multi_hand_landmarks:
                    hand_landmarks = []
                    for landmarks in results.multi_hand_landmarks:
                        hand = np.array([[lm.x, lm.y, lm.z] for lm in landmarks.landmark])
                        center = np.mean(hand[:, :2], axis=0)
                        hand[:, :2] -= center  # Center landmarks
                        max_distance = np.max(np.linalg.norm(hand[:, :2], axis=1))
                        hand /= max_distance
                        hand_landmarks.append(hand)
                    return hand_landmarks
                return None

            # Check perfect pose match
            def check_perfect_pose_match(user_hand_landmarks, predefined_hand_landmarks):
                if len(user_hand_landmarks) != len(predefined_hand_landmarks):
                    return False
                for i in range(len(user_hand_landmarks)):
                    if np.any(np.abs(user_hand_landmarks[i] - predefined_hand_landmarks[i]) > POSITION_TOLERANCE):
                        return False
                return True

            # Detect gestures
            def detect_finger_gesture(hand_landmarks):
                thumb_up = hand_landmarks[4, 1] < hand_landmarks[3, 1] and hand_landmarks[3, 1] < hand_landmarks[2, 1]
                peace_sign = hand_landmarks[8, 1] < hand_landmarks[7, 1] and hand_landmarks[12, 1] < hand_landmarks[11, 1]
                if thumb_up:
                    return "Thumb Up"
                elif peace_sign:
                    return "Peace Sign"
                return "Unknown Gesture"

            # Draw feedback
            def draw_hand_landmarks_with_feedback(frame, hand_landmarks, is_matched, gesture):
                color = (0, 255, 0) if is_matched else (0, 0, 255)
                for hand in hand_landmarks:
                    for lm in hand:
                        x, y = int(lm[0] * frame.shape[1]), int(lm[1] * frame.shape[0])
                        cv2.circle(frame, (x, y), 5, color, -1)
                cv2.putText(frame, gesture, (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)

            # Process frames
            video_hand_landmarks = get_normalized_hand_landmarks(frame_video_resized)
            webcam_hand_landmarks = get_normalized_hand_landmarks(frame_webcam)

            if video_hand_landmarks and webcam_hand_landmarks:
                is_matched = check_perfect_pose_match(webcam_hand_landmarks[0], video_hand_landmarks[0])
                gesture = detect_finger_gesture(webcam_hand_landmarks[0])
                draw_hand_landmarks_with_feedback(frame_webcam, webcam_hand_landmarks, is_matched, gesture)
                feedback_message = "Pose Matched!" if is_matched else "Pose Mismatched!"
                feedback_color = (0, 255, 0) if is_matched else (0, 0, 255)
            else:
                feedback_message = "No valid hand pose detected."
                feedback_color = (0, 0, 255)
                gesture = "None"

            cv2.putText(frame_webcam, feedback_message, (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, feedback_color, 2)
            cv2.imshow("Webcam Feed", frame_webcam)
            cv2.imshow("Reference Video", frame_video_resized)

            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                break
            elif key == ord('p'):
                pause_video = True
            elif key == ord('r'):
                pause_video = False
    except Exception as e:
        return {"error": str(e)}

    cap_video.release()
    cap_webcam.release()
    cv2.destroyAllWindows()
    return {"status": "completed"}


# Flask route to expose as API
@app.route('/compare_pose', methods=['POST'])
def compare_pose_api():
    data = request.json
    video_path = data.get("video_path")
    if not video_path:
        return jsonify({"error": "Video path is required"}), 400
    result = compare_pose_with_video(video_path)
    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True)
