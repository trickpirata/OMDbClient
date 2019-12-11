//
//  GPActivityIndicator.swift
//  OMDbClient
//
//  Created by Trick Gorospe on 12/10/19.
//  Copyright © 2019 Trick Gorospe. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension GPProgressHUD {
    public var progressDialogAnimation: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            switch (event) {
            case .next(let value):
                if value {
                    self.show()
                } else {
                   self.dismiss()
                }
            case .error( _):
                self.dismiss()
                break
            case .completed:
                break
            }
        }
    }
}

private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class GPActivityIndicator : SharedSequenceConvertibleType {
    public typealias Element = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O,isIncrementable increment: Bool) -> Observable<O.Element> {
        return Observable.using({ () -> ActivityToken<O.Element> in
            if increment {
                self.increment()
            }
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        _lock.lock()
        _variable.accept(_variable.value + 1)
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _variable.accept(_variable.value - 1)
        _lock.unlock()
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
    
    public func refreshActivityParentWindow() {
        
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: GPActivityIndicator) -> Observable<Element> {
        return activityIndicator.trackActivityOfObservable(self, isIncrementable: true)
    }
    
    
    /// Allows you to control if you want to show trackactivity using a logic.
    ///
    /// - Parameters:
    ///   - handler: return true if you want to show activity, else false
    ///   - indicator: indicator to show
    /// - Returns: observable
    public func trackActivity(_ handler: () -> Bool,withActivityIndicator indicator: GPActivityIndicator) -> Observable<Element> {
        return indicator.trackActivityOfObservable(self,isIncrementable: handler())
    }
}

