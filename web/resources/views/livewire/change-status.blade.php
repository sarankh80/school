<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
    <div class="form-check form-switch">
        <input type="checkbox" wire:model.lazy="status" {{ $disabled }} class="form-check-input"
            @if ($status) checked @endif>
    </div>
</div>
