#!/usr/bin/env python3

"""
Script that tests the `move_base` action client.

Example usage:
  Python: python3 test_move_base.py --x 0 --y 2 --theta 1.57
  rosrun: rosrun tb3_autonomy test_move_base.py --x 0 --y 2 --theta 1.57
"""

import tf
import rospy
import argparse
import actionlib
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal

def create_move_base_goal(x, y, theta):
    """ Creates a MoveBaseGoal message from a 2D navigation pose """
    goal = MoveBaseGoal()
    goal.target_pose.header.frame_id = "map"
    goal.target_pose.header.stamp = rospy.Time.now()
    goal.target_pose.pose.position.x = x
    goal.target_pose.pose.position.y = y
    quat = tf.transformations.quaternion_from_euler(0, 0, theta)
    goal.target_pose.pose.orientation.x = quat[0]
    goal.target_pose.pose.orientation.y = quat[1]
    goal.target_pose.pose.orientation.z = quat[2]
    goal.target_pose.pose.orientation.w = quat[3]
    return goal

if __name__=="__main__":
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Move base test script")
    parser.add_argument("--x", type=str, default="1.0")
    parser.add_argument("--y", type=str, default="0.0")
    parser.add_argument("--theta", type=str, default="0.0")
    args = parser.parse_args()

    # Start ROS node and action client
    rospy.init_node("test_move_base")
    client = actionlib.SimpleActionClient("move_base", MoveBaseAction)
    client.wait_for_server()

    # Send goal to the move_base action server
    print(f"Going to [x: {args.x}, y: {args.y}, theta: {args.theta}] ...")
    goal = create_move_base_goal(float(args.x), float(args.y), float(args.theta))
    client.send_goal(goal)
    result = client.wait_for_result()
    print(f"Action complete with result: {result}")
