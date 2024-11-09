<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
    <div class="form-check form-switch">
        <input type="checkbox" wire:model.lazy="visible" {{ $disabled }} class="form-check-input"
            @if ($visible) checked @endif>
    </div>
</div>
