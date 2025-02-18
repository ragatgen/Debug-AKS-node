#!/bin/bash
  
# List available nodes
echo "Available nodes:"
kubectl get nodes

# Prompt user for node name
echo -n "Enter the node name to debug: "
read NODE_NAME

# Validate input
if [ -z "$NODE_NAME" ]; then
    echo "Error: Node name cannot be empty."
    exit 1
fi

# Run the debug command
echo "Debugging node: $NODE_NAME..."
kubectl debug node/$NODE_NAME -it --image=mcr.microsoft.com/cbl-mariner/busybox:2.0 -- /bin/sh -c "
    chroot /host /bin/bash -c '
        echo \"Top memory-consuming processes on node $NODE_NAME:\";
        ps -eo pid,comm,%mem,rss,vsz --sort=-%mem | head -n 6;
    '
"

echo "Exited debug session for node: $NODE_NAME"
