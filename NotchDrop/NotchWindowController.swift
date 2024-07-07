//
//  NotchWindowController.swift
//  NotchDrop
//
//  Created by 秋星桥 on 2024/7/7.
//

import Cocoa

private let notchHeight: CGFloat = 200

class NotchWindowController: NSWindowController {
    let vm = NotchViewModel()

    init(window: NSWindow, screen: NSScreen) {
        super.init(window: window)
        contentViewController = NotchViewController(vm)

        let notchSize = screen.notchSize
        vm.deviceNotchRect = CGRect(
            x: screen.frame.origin.x + (screen.frame.width - notchSize.width) / 2,
            y: screen.frame.origin.y + screen.frame.height - notchSize.height,
            width: notchSize.width,
            height: notchSize.height
        )
        print("[i] notch rect in screen \(vm.deviceNotchRect)")

        window.makeKeyAndOrderFront(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else { return }
            vm.screenRect = screen.frame
            if !vm.isOpened { vm.isOpened = true }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError() }

    convenience init(screen: NSScreen) {
        let window = NotchWindow(
            contentRect: screen.frame,
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false,
            screen: screen
        )
        self.init(window: window, screen: screen)

        print("[i] this screen is having frame \(screen.frame)")
        let topRect = CGRect(
            x: screen.frame.origin.x,
            y: screen.frame.origin.y + screen.frame.height - notchHeight,
            width: screen.frame.width,
            height: notchHeight
        )
        print("[i] using this frame \(topRect)")
        window.setFrameOrigin(topRect.origin)
        window.setContentSize(topRect.size)
    }
}
