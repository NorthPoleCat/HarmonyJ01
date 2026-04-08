import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit'
import { Want } from '@kit.AbilityKit'
import { JSON } from '@kit.ArkTS'
import { FavoriteWordWidgetStore, FavoriteWordWidgetFormData } from '../tools/FavoriteWordWidgetStore'

interface FormMessagePayload {
  message?: string
}

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    const formId = this.getFormId(want)
    return formBindingData.createFormBindingData(
      FavoriteWordWidgetStore.currentData(this.context, formId)
    )
  }

  onUpdateForm(formId: string): void {
    void this.refreshForm(formId)
  }

  onFormEvent(formId: string, message: string): void {
    const action = this.parseMessage(message)
    if (action === 'prev') {
      void this.refreshForm(formId, -1)
      return
    }

    if (action === 'next') {
      void this.refreshForm(formId, 1)
    }
  }

  onRemoveForm(formId: string): void {
    FavoriteWordWidgetStore.removeFormState(this.context, formId)
  }

  onAcquireFormState(_want: Want): formInfo.FormState {
    return formInfo.FormState.READY
  }

  private getFormId(want: Want): string {
    const params = want.parameters as Record<string, Object> | undefined
    const rawFormId = params?.[formInfo.FormParam.IDENTITY_KEY]
    if (typeof rawFormId === 'string') {
      return rawFormId
    }
    if (typeof rawFormId === 'number') {
      return rawFormId.toString()
    }
    return 'default'
  }

  private parseMessage(message: string): string {
    if (message === 'prev' || message === 'next') {
      return message
    }

    try {
      const payload = JSON.parse(message) as FormMessagePayload
      return payload.message ?? ''
    } catch (_err) {
      return ''
    }
  }

  private async refreshForm(formId: string, step: number = 0): Promise<void> {
    const data: FavoriteWordWidgetFormData = step === 0
      ? FavoriteWordWidgetStore.currentData(this.context, formId)
      : FavoriteWordWidgetStore.move(this.context, formId, step)
    await formProvider.updateForm(formId, formBindingData.createFormBindingData(data))
  }
}
