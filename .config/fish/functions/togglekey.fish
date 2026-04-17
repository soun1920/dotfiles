function togglekey
    set device /sys/class/input/input2/inhibited
    set state (cat $device)
    if test $state = "0"
        echo 1 | sudo tee $device > /dev/null
        echo "内蔵キーボード: 無効"
    else
        echo 0 | sudo tee $device > /dev/null
        echo "内蔵キーボード: 有効"
    end
end
